class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.33.0.tar.gz"
  sha256 "549217aa54f1e6ab0bee7ebc80a5f8773fd54b974b9a319dac71509aa642bbb2"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ca838a3dbeffe8ee2ab6543b4ca5805075a5d8ac9008755968c43105733d022"
    sha256 cellar: :any_skip_relocation, big_sur:       "503014608a57e9600d60023b984c6605ae0a85e045cc7540b12a74c592aab637"
    sha256 cellar: :any_skip_relocation, catalina:      "ff379cdfa37d407f3e7f86012c5e20d239d8981a8deeca7368824cb1dcece9af"
    sha256 cellar: :any_skip_relocation, mojave:        "cbaeb5302fe3fddb0b5befd29f44e25b497db23a5dde6dedd2bdd575f6f9c9c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ff6c247de415f7d87767f467bba9fd0af3665e2e689ace48e8b92d39b8b588f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args,
              "-ldflags", "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
