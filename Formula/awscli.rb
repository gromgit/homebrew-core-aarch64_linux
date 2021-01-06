class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.16.tar.gz"
  sha256 "e679c91f4b33cce42df6fbeed144ec4dcbb3105d65ec3b84f568435761c97c77"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 "db192f087799f929eae2dba5833c5d0561b86167c7ac0cc317d334155086e2e1" => :big_sur
    sha256 "aeb7d0dbff7de73e051ab77a048f665bd7e7fdfa9d4e6ab10f41f7a194cb04cc" => :arm64_big_sur
    sha256 "20bf5b01ac0b5047410e8dcc2aa39c4c62be49b0c39194126e138273d9d6fa0e" => :catalina
    sha256 "9d47b4b127c64e6afbf5dfd4dd6cf985cf38d778f015ecff5ed0612b5af385f6" => :mojave
  end

  depends_on "python@3.9"

  uses_from_macos "groff"

  on_linux do
    depends_on "libyaml"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "-r", "requirements.txt",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pyinstaller"
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS

    system libexec/"bin/python3", "scripts/gen-ac-index", "--include-builtin-index"
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
    assert_include Dir["#{libexec}/lib/python3.9/site-packages/awscli/data/*"],
                   "#{libexec}/lib/python3.9/site-packages/awscli/data/ac.index"
  end
end
