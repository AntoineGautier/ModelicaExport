> [!NOTE]
> This document is an update of the [original requirement specification](https://github.com/lbl-srg/ctrl-flow-dev/blob/main/specification/requirements.html) to reflect the current state of development of MBL templates and of ctrl-flow. It focuses on a single section: "Class Manipulation and Workflow". In this document:
> - ❌ means that the implementation does not meet the requirement,
> - ⚠️ means that the implementation only partially meets the requirement,
> - ✅ means that the implementation meets the requirement.

### 3.3.4. Class Manipulation and Workflow

From the original template classes, the configuration workflow enables generating classes representing specific system configurations.
Those specific classes must be organized in a package structure (the user projects) complying with the Modelica specification.

> [!NOTE]
> Note that according to the specification, a package can be either a single file (for instance `NameOfPackage.mo`) or a directory containing a `package.mo` file, and the package file may itself include some definitions of subpackages. ❌ No support for single-file mapping.

The UI must provide a means to explore both the package containing the template classes and the package containing the specific classes (the user projects).

- A file explorer with a tree view should reveal the package structure in a left panel. ⚠️ → Currently, only a flat list of templates is supported.

- Only the classes defined in the package file, or enumerated in the `package.order` file shall be displayed. And they shall be displayed in the same order as the one specified by those two files. ❌ → The `package.order` content is not saved by modelica-json (FE in [#281](https://github.com/lbl-srg/modelica-json/pull/281)), ctrl-flow doesn't use it.

- The left panel is divided vertically in two parts: the upper part for the templates, the lower part for the user projects. ⚠️ → Currently, the system configurations are "nested" under the corresponding template — this design choice raises the question about multiple project support.

- The description string of each class must be displayed, for instance when hovering a package or a model in the file explorer. ✅ → Description strings are displayed by default, class names are not.

The following example illustrates typical package structures and the way they should be displayed in the UI.

*Listing 3.1 Example of the package structure for the templates and user projects (in the file system)*

```
Buildings
├── Templates                 # Contains __ctrlFlow(routing="root").
│   ├── AHUs
│   │   ├── Data
│   │   ├── package.mo
│   │   ├── package.order
│   │   └── VAVSingleDuct.mo  # Contains __ctrlFlow(routing="template").
│   ├── BoilerPlants
│   │   └── ...               # Enclosed templates with __ctrlFlow(routing="template") annotation.
│   ├── ChillerPlants
│   │   └── ...               # Enclosed templates with __ctrlFlow(routing="template") annotation.
│   ├── TerminalUnits
│   │   └── ...               # Enclosed templates with __ctrlFlow(routing="template") annotation.
│   ├── package.mo
│   └── package.order
├── ...
├── package.mo
└── package.order

UserProjects
├── Project_1
│   ├── AHUs
│   │   ├── Data
│   │   ├── package.mo
│   │   ├── package.order
│   │   └── VAV_1.mo
│   ├── BoilerPlants
│   │   └── ...
│   ├── ChillerPlants
│   │   └── ...
│   ├── TerminalUnits
│   │   └── ...
│   ├── package.mo
│   └── package.order
├── {Project_i}
│   └── ...
├── package.mo
└── package.order
```

This should be rendered in the UI as follows.

*Listing 3.2 Example of the rendering of the package structure in the UI*

```
Buildings
├── AHUs
│   └── VAVSingleDuct
├── BoilerPlants
│   └── ...
├── ChillerPlants
│   └── ...
└── TerminalUnits
    └── ...

UserProjects
├── Project_1
│   ├── AHUs
│   │   ├── VAV_1
│   │   └── Data
│   ├── BoilerPlants
│   │   └── ...
│   ├── ChillerPlants
│   │   └── ...
│   └── TerminalUnits
│       └── ...
└── {Project_i}
    └── ...
```

The suggested workflow is as follows.

1. The template package of the Modelica Buildings Library is preloaded. ✅
   The tool provides the option to load additional template packages from third-party libraries. ⚠️ → Under development in [`issue431_multiLibs`](https://github.com/lbl-srg/ctrl-flow-dev/tree/issue431_multiLibs) but only at ***build time***, not at runtime.
   A template package is identified by the class annotation `__ctrlFlow(routing="template")` in the package file.

    - Only the classes with the annotation `__ctrlFlow(routing="template")` should be displayed in the template file explorer. ✅

2. The user can select whether to create a `UserProjects` from scratch or to load a package stored locally on the device. ❌ → No mechanism to upload a Modelica package, UI designed to include configurations under the corresponding templates.

    - If a new package is created, it must contain the class annotation `uses(Buildings(version="..."), ...)` with the version of all loaded libraries.
    - Library version management: If a loaded class contains the Modelica annotation `uses` (e.g., `uses(Buildings(version="6.0.0")`) the software checks the version number of the stored library. If the version number does not match, the tool simply alerts the user of version incompatibility.

3. The user can create a new project, for instance by right clicking on `UserProjects` which renders a menu with the options *Add New*, etc. ❌ → No logic to support multiple projects.

4. The user can select the working project to save the new specific classes, for instance by right clicking on `Project_1` which opens a menu with the options *Set as Working Project*, *Rename*, *Delete*, etc. ❌

    - The current working project must be clearly highlighted in the user projects file explorer.

5. The user selects a template to start the configuration workflow, for instance by right clicking on `VAVSingleDuct` which renders a menu with the option *Start Configuring*, etc. ✅ → Different UX but equivalent functionality.

6. A specific class is created under the corresponding subpackage (for instance `AHUs`) of the current working project in the `UserProjects` package. ⚠️ → A configuration is created under the corresponding template, the concept of a Modelica package is invisible to the user.

    - The new class is constructed by extending the original template `extends type-specifier [ class-modification ] [annotation]`. ❌ → No Modelica code is generated, the class modification is stored as a "form option" in a flat key-value object.

    - The parameter dialog of the template class is generated in the configuration panel. ✅
    In addition, two input fields allows specifying the simple name and the description string of the specific class to be generated. ⚠️ → A single field is used to input the configuration name.

    - The tree view of the `UserProjects` package is updated dynamically, based on the class name and the class description string input by the user. ✅

    - Any user input leads to updating the specific class definition. The full composed name (dot notation starting from the top-level library package, for instance `Buildings`) shall be used to reference each class used in the class definition. ❌ → No Modelica code is generated

7. Optionally, a record class with the same simple name is created under the corresponding subpackage, for instance `AHUs.Data`. The record contains the same class modifications as the ones applied to the records of the specific class. This will allow the user to further use this record to propagate the parameters of an instance of the specific class to a top-level simulation model. ❌

8.  At least two action buttons *Save* and *Cancel* are required in the configuration panel. The class within the `UserProjects` package is only modified upon Save. All the modifications are reset to the last saved state upon *Cancel*. ✅ → Different UX but equivalent functionality.

9.  Once created, the user can select each specific class from the user projects file explorer and further modify it, for instance by right clicking on the corresponding class which renders a menu with the options *Edit Class*, *Delete*, *Rename*, *Duplicate*, etc. ✅ → Different UX but equivalent functionality w/o *Duplicate* though.

10. Export functionalities (Modelica code or documentation) are available from the user projects file explorer, at the level of the package and at the level of the specific class. ⚠️ → No logic to support multiple projects — the export functionality targets all the specified configurations.
