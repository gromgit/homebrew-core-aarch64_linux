class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/2.2.25.tar.gz"
  sha256 "05d6e8bb10e5163d2731dbf3bef5d546a5ae96406122156ea95f8b9c8e3a77ae"
  license "Apache-2.0"
  head "https://github.com/aws/aws-cli.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ebed1b58c5103f07129560e1cca43f2a687b396b10eeabb1327c5ac7e8f3940c"
    sha256                               big_sur:       "0ee58694234b376005995a4407f0e7be3b9016ed2e28d42cc2e0960e718571ef"
    sha256                               catalina:      "f481bcdf700d85a7281a6cd43b289f08f711880b549f16c3cbdea5493e5b08a0"
    sha256                               mojave:        "829ebc5de2bef5085a56a44c138582e10be067b16a8d399f761d81d9be07941e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8ef5187cd9e1ac9b1490fae55856700efd2303cc219190fff7befe9b46c854"
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
