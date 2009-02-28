require File.dirname(__FILE__) + '/../../../lib/buildmaster/auto'
require 'spec'

module BuildMaster
  describe JUnitAnt do
    it 'should create ANT build file, and jvmargs' do
      report = Cotta.new(InMemorySystem.new).dir('report')
      junit = JUnitAnt.new(report).for_test('org.rubyforge.AllTests')
      junit.jvmargs.push('jvmargument')
      junit.generate
      build_file = report.file('junit-ant.xml')
      build_file.load.should == <<RESULT
<!-- ANT file generated by buildmaste JUnitAnt -->
<project name="junit-ant" default="junit-ant">


  <target name="junit-ant">

    <junit printsummary="yes" fork="yes" forkmode="perBatch" errorproperty="error" failureproperty="failure" haltonerror="no" haltonfailure="no">
      <formatter type="xml"/>
      <jvmarg line="jvmargument"/>
      <test name="org.rubyforge.AllTests" todir="#{report}/test"/>
    </junit>
    <junitreport todir="#{report}/test">
        <fileset dir="#{report}/test">
            <include name="TEST-*.xml"/>
        </fileset>
        <report todir="#{report}/test" format="frames"/>
    </junitreport>

    <fail message="test failed">
      <condition>
        <or>
          <isset property="fail"/>
          <isset property="error"/>
        </or>
      </condition>
    </fail>
  </target>
</project>
RESULT
    end

    it 'should create with classpath' do
      report = Cotta.new(InMemorySystem.new).dir('report')
      junit = JUnitAnt.new(report).for_test('AllTests')
      junit.classpath.add(report.file('one'))
      junit.generate(report.file('xml.xml'))
      report.file('xml.xml').load.should == <<RESULT
<!-- ANT file generated by buildmaste JUnitAnt -->
<project name="junit-ant" default="junit-ant">

  <path id="refid">
    <pathelement location="report/one"/>
  </path>

  <target name="junit-ant">

    <junit printsummary="yes" fork="yes" forkmode="perBatch" errorproperty="error" failureproperty="failure" haltonerror="no" haltonfailure="no">
      <formatter type="xml"/>
      <classpath refid="refid"/>
      <test name="AllTests" todir="#{report}/test"/>
    </junit>
    <junitreport todir="#{report}/test">
        <fileset dir="#{report}/test">
            <include name="TEST-*.xml"/>
        </fileset>
        <report todir="#{report}/test" format="frames"/>
    </junitreport>

    <fail message="test failed">
      <condition>
        <or>
          <isset property="fail"/>
          <isset property="error"/>
        </or>
      </condition>
    </fail>
  </target>
</project>
RESULT
    end

    it 'should create with batch test set up' do
      report = Cotta.new(InMemorySystem.new).dir('report')
      project = JavaProject.new(report)
      project.test.src = report.dir('test')
      junit = JUnitAnt.new(report, project).for_tests('**.java')
      junit.generate(report.file('xml.xml'))
      report.file('xml.xml').load.should == <<RESULT
<!-- ANT file generated by buildmaste JUnitAnt -->
<project name="junit-ant" default="junit-ant">


  <target name="junit-ant">

    <junit printsummary="yes" fork="yes" forkmode="perBatch" errorproperty="error" failureproperty="failure" haltonerror="no" haltonfailure="no">
      <formatter type="xml"/>
      <batchtest fork="yes" todir="#{report}/test">
        <fileset dir="#{project.test.src}">
          <include name="**/**.java"/>
        </fileset>
      </batchtest>
    </junit>
    <junitreport todir="#{report}/test">
        <fileset dir="#{report}/test">
            <include name="TEST-*.xml"/>
        </fileset>
        <report todir="#{report}/test" format="frames"/>
    </junitreport>

    <fail message="test failed">
      <condition>
        <or>
          <isset property="fail"/>
          <isset property="error"/>
        </or>
      </condition>
    </fail>
  </target>
</project>
RESULT
    end

    it 'should create tasks for cobertura' do
      report = Cotta.new(InMemorySystem.new).dir('report')
      project = JavaProject.new(report)
      project.src = report.dir('src')
      project.output = report.dir('output')
      junit = JUnitAnt.new(report, project).for_test('All')
      cobertura = report.file('cobertura.jar').save
      cobertura.parent.dir('lib').mkdirs
      junit.with_coverage(cobertura)
      junit.generate(report.file('xml.xml'))
      report.file('xml.xml').load.should == <<RESULT
<!-- ANT file generated by buildmaste JUnitAnt -->
<project name="junit-ant" default="junit-ant">
  <path id="coverage">
    <pathelement location="report/cobertura.jar"/>
    <fileset dir="report/lib">
      <include name="**/*.jar"/>
    </fileset>
  </path>
  <taskdef classpathref="coverage" resource="tasks.properties"/>

  <path id="refid">
    <pathelement location="report/output/instrumented"/>
    <pathelement location="report/cobertura.jar"/>
  </path>

  <target name="junit-ant">
    <cobertura-instrument todir="report/output/instrumented" datafile="report/output/cobertuna.ser">
        <fileset dir="report/output/prod">
            <include name="**/*.class"/>
        </fileset>
    </cobertura-instrument>
    <copy todir="report/output/instrumented">
      <fileset dir="report/output/prod" excludes="**/*.class"/>
    </copy>

    <junit printsummary="yes" fork="yes" forkmode="perBatch" errorproperty="error" failureproperty="failure" haltonerror="no" haltonfailure="no">
      <formatter type="xml"/>
<sysproperty key="net.sourceforge.cobertura.datafile" file="report/output/cobertuna.ser" />
      <classpath refid="refid"/>
      <test name="All" todir="report/test"/>
    </junit>
    <junitreport todir="report/test">
        <fileset dir="report/test">
            <include name="TEST-*.xml"/>
        </fileset>
        <report todir="report/test" format="frames"/>
    </junitreport>
    <cobertura-report srcdir="report/src" destdir="report/coverage" datafile="report/output/cobertuna.ser"/>

    <fail message="test failed">
      <condition>
        <or>
          <isset property="fail"/>
          <isset property="error"/>
        </or>
      </condition>
    </fail>
  </target>
</project>
RESULT
    end
  end
end
