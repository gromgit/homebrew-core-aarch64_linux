class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.1.25.tar.gz"
  sha256 "31f4cde7e0b8fd02afc42700362d54a5902c5d536fad4e3044a772df6ba03767"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4d4f9e7fddabfda1baf1a2d4a3ed67bd9e3e2d98193ee25bc3ceb1f580465b17"
    sha256               big_sur:       "522398cc0467e88d41ef646183a34b8a5188c5b3fe79fe61ccd0e6f588bc8bf8"
    sha256               catalina:      "cd9f5ecc59a60a5dacadc7a5f3ba51ea2baefd02450f26d431671a2495583324"
    sha256               mojave:        "e6587ca174dcf9c6e6548154d0dd2dfa9e229b1d5707be29f949b34bf2a91a9d"
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
