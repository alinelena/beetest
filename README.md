Beetest is a tool designed to run batch jobs and analyze the output. It is specifically adapted for use with electronic structure programs, but the way you construct a test suite is very flexible, so it should work with many other programs as well.

Suggested usage:

1. Put some folders with input files into a folder called "Tests". These are your "tests" / "jobs" / "calculations". Make sure that they are set to start from scratch every time (e.g. for the VASP program, one would set ISTART=0).

2. Write some scripts to extract interesting results from your output files (e.g.). Place these in a folder called "Scripts".

3. Make a file with XML syntax defining your test suite. See "beetest.xml" for a detailed example. The idea is to first connect each script to a property to be examined. Then, you make test cases using these defined properties. Below are examples from the VASP test suite. First is a definition of the property "energy", which describes to the total energy of a cell. It is a floating point number, which we examine with 1.0E-5 relative precision. 

  <properties>    
    <property name="energy">
      <description>Total energy (eV)</description>
      <script>Scripts/Energy.sh</script>
      <type>Float</type>
      <relativeprecision>1.0E-5</relativeprecision>
    </property>
    ...
  </properties>

The next snippet shows a test suite with an actual calculation which we will (among other things) check the total energy of:

  <testsuite name="quick">
    <description>VASP 4/5 (small calculations)</description>
    <date>2011-07-18</date>
    <author>Peter Larsson</author>
      
    <testcase name="Fe bcc spin-polarized">
      <path>Tests/Fe-bcc</path>
      <energy>-8.431093</energy>
      <pressure>-22.18</pressure>
      <fermi tolerance="0.001">9.629837</fermi>
      ...
    </testcase>
    
    ...
  </testsuite>
To change the acceptance value for only one test you can use the attribute tolerance for that property in the corresponding testcase. The value specified has precendence over the general value of the property but they will share the same type (see <fermi> above)
In the end, you should have a directory structure looking like this:

  VASPTestSuite/
    |---Tests/
    |     |---Cu-fcc/
    |     |---Fe-bcc/
    |     |---Fe-bcc/
    |     |---Si-cd/
    |     |---TiO2-rutile/
    |---Scripts/
    |     |---Energy.sh
    |     |---Pressure.sh
    |     |---Volume.sh
    |     |---Forces.sh
    |
    |---beetest.xml

4. Execute the beetest script together with the name of an executable to run the tests. The script will look for the file "beetest.xml" in the same directory if no file names are given.

$ beetest /opt/vasp/5.2.12/bin/vasp

(The run an MPI-parallel program use e.g. beetest "mpirun -n 8 /opt/vasp/5.2.12/bin/vasp" instead)

The output will look like this for a successful run:

  Beetest (development version)

  -----------------------------------| Test suite: quick |------------------------------------
  Running Fe bcc spin-polarized...
   * Total energy (eV)..................................................................[ OK ]
   * Fermi energy (eV)..................................................................[ OK ]
   * Band energy (eV)...................................................................[ OK ]
   * Cell Pressure (kPa)................................................................[ OK ]
   ...
  Summary

     Passed: 4
     Failed: 0
     Errors: 0

  Status: PASSED
  --------------------------------| End of test suite: quick |--------------------------------

Test failures will look like this:

  Running CHFe chain...
   * Total energy (eV)..............................................................[ FAILED ]
       Actual result:                        -316.690431
       Expected result:                      -316.506647
       Delta:                                 -1.838e-01
  Summary

     Passed: 6
     Failed: 2
     Errors: 0

  Status: FAILED
  -----------------------------| End of test suite: production |------------------------------
5. Execute the tests with output in a different folder using -o option
beetest -o TestsOut -v -k -s quick "mpiexec -n 8  vasp "

Also you can specify the output folder for a testsuite inside the xml using <outdir> and 
 the input and output for a specific test using <input> and <output>
 
  <testsuite name="fast">
    ...
    <outdir>TestsOut</outdir>
    ...
    <testcase name="Au_wire_1kp">
      <path>Tests/Au_wire_1kp</path>
      <input>input.fdf</input>
      <output>out</output>
    ...
    </testcase>
   ...
  </testsuite>

The structure of the output shall be like this after running the above
  VASPTestSuite/
    |---Tests/
    |     |---Cu-fcc/
    |     |---Fe-bcc/
    |     |---Fe-bcc/
    |     |---Si-cd/
    |     |---TiO2-rutile/
    |---TestsOut/
    |     |---Cu-fcc/
    |     |---Fe-bcc/
    |     |---Fe-bcc/
    |     |---Si-cd/
    |     |---TiO2-rutile/
    |---Scripts/
    |     |---Energy.sh
    |     |---Pressure.sh
    |     |---Volume.sh
    |     |---Forces.sh
    |
    |---beetest.xml

