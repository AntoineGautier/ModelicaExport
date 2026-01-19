# CDL Export

Feature enhancements to modelica-json in order to support exporting the control logic from a template class, namely:

- Extract all the CDL blocks that form the control sequence
- Parameter assignments: Develop JS functions to evaluate Modelica expressions (may include functions calls, for loops, array constructs) and include literal values in exported doc and CDL

## MBL Templating Contract

All blocks that constitute the control sequence of a template class (further referred to as "qualified") are instantiated within a single component (the control section) named `ctl` .

- This may include safety functions with hardwired logic as specified in ASHRAE Guideline 13 (smoke detection, freeze protection). At the time of writing it is not a requirement to export those safety functions (defined outside of G36) as part of the control sequence.

- The component `ctl` itself is not [CDL-compliant](https://obc.lbl.gov/specification/requirements.html#cdl) because it contains
  - `inner`/`outer` declarations (for example, project-level parameters such as the energy or ventilation standard),
  - expandable connectors,
  - an initial equation section,
  - non-permissible data types (for instance `Modelica.Units.SI.*`),
  - parameter assignments using record instances or `inner`/`outer` declarations (see below).

> [!Important]
> Parameter assignments within the control section use only expressions permitted in CDL. See https://obc.lbl.gov/specification/cdl.html#parameter-declaration-and-assigning-of-values-to-parameters for details.

All connect clauses between the qualified blocks within `ctl` have a graphical annotation (so there are visible connection lines representing those connections). Most of the other connect clauses have no graphical annotation, typically the connection to a sensor or actuator signal.

All outside connectors are sub-connectors of expandable connectors (control bus).
However, the bus architecture used in the Modelica templates is devised for modeling. It does not reflect the BAS bus architecture but only "mimics" it. For instance

- we use an array of terminal unit bus in the control section of the air handler, whereas a BAS register each terminal point to a single point in a flat bus,
- some signals may actually be hardwired in the BAS, such as the ones used for safety functions.

## CDL-JSON Export

Given that contract, the control section `ctl` cannot be exported as is when generating the CDL-JSON representation of the control sequence.

- Only the following classes shall be exported:
  - (qualified) classes from `Buildings.Controls.OBC`.
  - classes that contain any annotation starting with `__cdl` (this allows users to provide custom-CDL compliant libraries of sequences).

- The export shall preserve the connect clauses between the qualified instances.

- Some expressions used for parameter assignments shall be evaluated and replaced with literal values (see below).

> [!NOTE]
> CDL now allows `extends` statements with `redeclare` clauses: [https://obc.lbl.gov/specification/cdl.html#extension-of-a-composite-block](https://obc.lbl.gov/specification/cdl.html#extension-of-a-composite-block).
> These clauses must also interpreted to export CDL from a template. :question: Is this supported by modelica-json?

:question: Do we want (for instance when a project specifies 10 AHU with the same control sequence but different operating parameters)

1. one exported file for each control sequence, and control parameters in separate section of the exported file, or a separate file?, or
2. one exported file for each combination of {control sequence, control parameters}.

The first option shall be the default. Generating the 2nd option via a command-line flag may be added if there is request for this functionality.

:question: Are Modelica records allowed in CDL? [mwetter: No, we have not used them. Let's discuss. I think this should not be problematic.] Those are used to store the values of system and control parameters in the Templates package. Modelica records are not explicitly excluded nor explicitly included according to https://obc.lbl.gov/specification/cdl.html#syntax. If they are not allowed, should we adopt another data structure in the Templates package?

## Parameter Evaluation

In addition to what is described at https://obc.lbl.gov/specification/cdl.html#evaluation-of-assignment-of-values-to-parameters the new issue that the templates raise is that the assignment of the propagated parameter (`pRel` in the example from the link) may use variables from the equipment model, which are therefore outside of the CDL scope (not within the qualified instances).

The following algorithm resolves parameter assignments when exporting the control sequence with modelica-json (either in English language or in CDL-JSON).

1. Parse the parameter bindings of each qualified instance.
2. Look up for the assignment of the propagated parameter and handle according to the cases below.

#### Case 1: Literal Assignment

Nothing to do, export as is.

#### Case 2: Variable Assignment (e.g., `dat.yFanRet_min`)

The value is to be found in the corresponding parameter record (also exported).

**Open question:** Leave the reference as is? Or convert it using the class name from the Modelica package representing the user project?

For instance, do we keep the original declaration from the Modelica template:

```mo
parameter Buildings.Templates.AirHandlersFans.Components.Data.VAVMultiZoneController dat;
```

Or do we convert it to:

```mo
parameter UserProject.AirHandlersFans.Data.VAV_1 dat;
```

(This option is not compatible with only one exported file for each control sequence: instead we end up with one exported file for each physical system.)

#### Case 3: Assignment Using an Expression

The expression must be evaluated. By contract, it involves only expressions permitted in CDL.

The expression may involve variables from:

- **Qualified instances:** Recursively apply this algorithm to evaluate.
- **Non-qualified instances** (typically from the equipment model), for example:

  ```mo
  final parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes =
    if secOutRel.typSecOut == Buildings.Templates.AirHandlersFans.Types.OutdoorSection.SingleDamper
    then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
    elseif secOutRel.typSecOut == Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersAirflow
    then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_AFMS
    elseif secOutRel.typSecOut == Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersPressure
    then Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.SeparateDamper_DP
    else Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper
  ```

  or

  ```mo
  VPriSysMax_flow = secOutRel.mAirSup_flow_nominal / 1.2
  ```

Look up for the assignment of the propagated parameter, which resolves to a previous case:

- An assignment from the parameter record such as `mAirSup_flow_nominal = dat.damOut.m_flow_nominal`, or
- A literal assignment such as `typSecOut = Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersAirflow`.

Note that those variables may be within `inner/outer` components.

:question: Are conditional expressions `a = if b then c else d` allowed in CDL? [mwetter: Currently they are not allowed as we did not see a need, but if modelica-json can handle it and there is a use case, I see no problem adding it.]

## Connections to Variables from the Equipment Model

All those variables (outside connectors) are sub-connectors of expandable connectors from the control section `ctl`.
For instance within `Buildings.Templates.AirHandlersFans.Components.Controls.G36VAVMultiZone`:

```mo
connect(bus.pAirSup_rel, ctl.ducStaPre);
connect(bus.TOut, ctl.TOut);
```

The [CDL specification](https://obc.lbl.gov/specification/requirements.html#cdl) states

> 2. CDL shall be able to express control sequences and their linkage to an object model which represents the plant.

To express such linkage in CDL, the connect clauses involving expandable connectors (not allowed in CDL) must be preprocessed.

Possible workflow

- Generate Modelica-JSON for a configuration class (extending a template class)
- _Flatten `extends` statements and resolve redeclarations_
  - :question: Is this supported by modelica-json?
- Generate a semantic model out of that JSON
  - :question: Has `node modelica-json\app.js -o cxf` been tested with complex models?
- Prune equipment model components
- Generate CDL-JSON

[pehrlich2020: About the use of semantic tagging specifically for system inputs and outputs. These will help provide valuable clues for the system integrator who is going to import CXF and use it as part of their control logic. Currently we have envisioned the tags — so the data would be mostly human readable. In the future perhaps a standard could be created for machine readable data to automate some of the integration. But this is not something that is likely to be viable today — mainly due to the lack of consistency in commercial control systems.]
