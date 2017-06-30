require 'spec_helper_acceptance'

describe 'jenkins class' do

  context 'default parameters' do
    it 'should work with no errors' do
      pp = <<-EOS
      class {'jenkins':
        cli_remoting_free => true,
      }

      jenkins::plugin {'git-plugin':
        name    => 'git',
        version => '2.3.4',
      }
      EOS

      # Run it twice and test for idempotency
      apply(pp, :catch_failures => true)
      apply(pp, :catch_failures => true)
    end

    it_behaves_like 'has_git_plugin'
  end

  describe 'plugin purging' do
    context 'true' do
      include_context 'plugin_test_files'

      it 'should work with no errors' do
        pp = <<-EOS
        class {'jenkins':
          cli_remoting_free => true,
          purge_plugins     => true,
        }

        jenkins::plugin {'git-plugin':
          name    => 'git',
          version => '2.3.4',
        }
        EOS

        apply2(pp)
      end

      it_behaves_like 'has_git_plugin'

      ($dirs + $files).each do |f|
        describe file(f) do
          it { should_not exist }
        end
      end
    end # true

    context 'false' do
      include_context 'plugin_test_files'

      it 'should work with no errors' do
        pp = <<-EOS
        class {'jenkins':
          cli_remoting_free => true,
          purge_plugins     => false,
        }

        jenkins::plugin {'git-plugin':
          name    => 'git',
          version => '2.3.4',
        }
        EOS

        apply2(pp)
      end

      it_behaves_like 'has_git_plugin'
>>>>>>> 23df776... Merge pull request #752 from elconas/fix_749

  end

end
