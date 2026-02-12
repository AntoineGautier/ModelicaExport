within;
model RecordExtension
  record Data
    parameter Real param = 0;
  end Data;

  record DataExt
    extends Data;
    parameter Real new_param = 1;
  end DataExt;

  model Component
    parameter Data data;
  initial equation
    Modelica.Utilities.Streams.print(
      "*** Parameter value is: " + String(data.param));
  end Component;

  record ComponentData
    /*
    This is the equivalent of UserProject/Data/AirHandlersFans.mo
    */
    replaceable parameter DataExt [2] data(new_param={2, 3})
      constrainedby Data(param={4, 5});
  end ComponentData;

  record AllSystems
    /*
    This is the equivalent of UserProject/Data/AllSystems.mo
    */
    extends ComponentData(redeclare Data data);
  end AllSystems;

  parameter AllSystems datAll;
  Component comp(data=datAll.data[1]);
annotation(Documentation="<html>
<p>
  This model describes how type-compatible records can be created to store
  additional parameters that are not required by component models. The
  relevant parameters can be accessed by extending the instance of the derived
  record type and redeclaring the nested array instance. This extend/redeclare
  pattern shall typically be implemented in
  <code>UserProject/Data/AllSystems.mo</code>.
</p>
</html>");
end RecordExtension;
