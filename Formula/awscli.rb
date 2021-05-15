class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.5.tar.gz"
  sha256 "608f621f7b71e9f7d45ff9a78e05d15c1635e53f14697457d73b518d9d932da5"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ec2037108c787c8f8c8d2c68bed604de8328043b56d9247e7a429f727d455385"
    sha256               big_sur:       "a7d80cf7dd99d2c3ffa15f512898d8a3c9b3158a412cdaea9090e066fb15841a"
    sha256               catalina:      "942ac0f741cf51bbf6c8fcf6a611a85d92d16d7db3242daa7324d081e4b9976d"
    sha256               mojave:        "f7dc250c83789d37747744b4da49180ae87ffe2966bc6ddc136fbd1c0902a5bd"
  end

  depends_on "cmake" => :build
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
    assert_includes Dir["#{libexec}/lib/python3.9/site-packages/awscli/data/*"],
                    "#{libexec}/lib/python3.9/site-packages/awscli/data/ac.index"
  end
end
