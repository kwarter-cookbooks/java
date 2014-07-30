require 'spec_helper'

describe 'java::openjdk' do
  platforms = {
<<<<<<< HEAD
    'ubuntu' => {
      'packages' => ['openjdk-6-jdk', 'default-jre-headless'],
      'versions' => ['10.04', '12.04'],
      'update_alts' => true
    },
    'centos' => {
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
      'versions' => ['5.8', '6.3'],
      'update_alts' => true
    },
    'smartos' => {
      'packages' => ['sun-jdk6', 'sun-jre6'],
      'versions' => ['joyent_20130111T180733Z'],
=======
    'ubuntu-10.04' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true
    },
    'ubuntu-12.04' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true
    },
    'debian-6.0.5' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true
    },
    'debian-7.0' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true
    },
    'centos-6.4' => {
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
      'update_alts' => true
    },
    'smartos-joyent_20130111T180733Z' => {
      'packages' => ['sun-jdk6', 'sun-jre6'],
>>>>>>> upstream/master
      'update_alts' => false
    }
  }

<<<<<<< HEAD
  # Regression test for COOK-2989
  context 'update-java-alternatives' do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04').converge('java::openjdk')
    end

    it 'executes update-java-alternatives with the right commands' do
      # We can't use a regexp in the matcher's #with attributes, so
      # let's reproduce the code block with the heredoc + gsub:
      code_string = <<-EOH.gsub(/^\s+/, '')
      update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java 1061 && \
      update-alternatives --set java /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java
      EOH
      expect(chef_run).to execute_bash_script('update-java-alternatives').with(:code => code_string)
    end
  end

  platforms.each do |platform, data|
    data['versions'].each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) do
          ChefSpec::ChefRunner.new(:platform => platform, :version => version).converge('java::openjdk')
        end

        data['packages'].each do |pkg|
          it "installs package #{pkg}" do
            expect(chef_run).to install_package(pkg)
          end

          it 'sends notification to update-java-alternatives' do
            expectation = data['update_alts'] ? :to : :not_to
            expect(chef_run.package(pkg)).send(expectation, notify("bash[update-java-alternatives]", :run))
          end
        end
=======
  platforms.each do |platform, data|
    parts = platform.split('-')
    os = parts[0]
    version = parts[1]
    context "On #{os} #{version}" do
      let(:chef_run) { ChefSpec::Runner.new(:platform => os, :version => version).converge(described_recipe) }

      data['packages'].each do |pkg|
        it "installs package #{pkg}" do
          expect(chef_run).to install_package(pkg)
        end
      end

      it 'sends notification to update-java-alternatives' do
        if data['update_alts']
          expect(chef_run).to set_java_alternatives('set-java-alternatives')
        else
          expect(chef_run).to_not set_java_alternatives('set-java-alternatives')
        end
      end
    end
  end

  describe 'conditionally includes set attributes' do
    context 'when java_home and openjdk_packages are set' do
      let(:chef_run) do
        runner = ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        )
        runner.node.set['java']['java_home'] = "/some/path"
        runner.node.set['java']['openjdk_packages'] = ['dummy','stump']
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to_not include_recipe('java::set_attributes_from_version')
      end
    end

    context 'when java_home and openjdk_packages are not set' do
      let(:chef_run) do
        runner = ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        )
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to include_recipe('java::set_attributes_from_version')
>>>>>>> upstream/master
      end
    end
  end

  describe 'license acceptance file' do
    {'centos' => '6.3','ubuntu' => '12.04'}.each_pair do |platform, version|
      context platform do
        let(:chef_run) do
<<<<<<< HEAD
          ChefSpec::ChefRunner.new(:platform => platform, :version => version).converge('java::openjdk')
=======
          ChefSpec::Runner.new(:platform => platform, :version => version).converge('java::openjdk')
>>>>>>> upstream/master
        end

        it 'does not write out license file' do
          expect(chef_run).not_to create_file("/opt/local/.dlj_license_accepted")
        end
      end
    end

    context 'smartos' do
      let(:chef_run) do
<<<<<<< HEAD
        ChefSpec::ChefRunner.new(:platform => 'smartos', :version => 'joyent_20130111T180733Z', :evaluate_guards => true)
=======
        ChefSpec::Runner.new(:platform => 'smartos', :version => 'joyent_20130111T180733Z', :evaluate_guards => true)
>>>>>>> upstream/master
      end

      context 'when auto_accept_license is true' do
        it 'writes out a license acceptance file' do
          chef_run.node.set['java']['accept_license_agreement'] = true
<<<<<<< HEAD
          expect(chef_run.converge('java::openjdk')).to create_file("/opt/local/.dlj_license_accepted")
=======
          expect(chef_run.converge(described_recipe)).to create_file("/opt/local/.dlj_license_accepted")
>>>>>>> upstream/master
        end
      end

      context 'when auto_accept_license is false' do
        it 'does not write license file' do
          chef_run.node.set['java']['accept_license_agreement'] = false
<<<<<<< HEAD
          expect(chef_run.converge('java::openjdk')).not_to create_file("/opt/local/.dlj_license_accepted")
        end
      end
    end

=======
          expect(chef_run.converge(described_recipe)).not_to create_file("/opt/local/.dlj_license_accepted")
        end
      end
    end
  end

  describe 'default-java' do
    context 'ubuntu' do
      let(:chef_run) do
        ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        ).converge(described_recipe)
      end

      it 'includes default_java_symlink' do
        expect(chef_run).to include_recipe('java::default_java_symlink')
      end
    end

    context 'centos' do
      let(:chef_run) do
        ChefSpec::Runner.new(
          :platform => 'centos',
          :version => '6.4'
        ).converge(described_recipe)
      end

      it 'does not include default_java_symlink' do
        expect(chef_run).to_not include_recipe('java::default_java_symlink')
      end
    end
>>>>>>> upstream/master
  end
end
