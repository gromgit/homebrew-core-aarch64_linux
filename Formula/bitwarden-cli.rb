require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.10.0.tgz"
  sha256 "93a952c653577a388ba29821edccd6db62155cd267e2a46c808aa77c48b47b14"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ff48c502252c875ec0e48e12e5450ff41645e9676cc3caee9636a2ded520e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ff48c502252c875ec0e48e12e5450ff41645e9676cc3caee9636a2ded520e4"
    sha256 cellar: :any_skip_relocation, monterey:       "b7954ff0052cdfa6aca3a7eb177c216beeeab5ce5798eb8997410512f07e54b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7954ff0052cdfa6aca3a7eb177c216beeeab5ce5798eb8997410512f07e54b1"
    sha256 cellar: :any_skip_relocation, catalina:       "b7954ff0052cdfa6aca3a7eb177c216beeeab5ce5798eb8997410512f07e54b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ff48c502252c875ec0e48e12e5450ff41645e9676cc3caee9636a2ded520e4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
