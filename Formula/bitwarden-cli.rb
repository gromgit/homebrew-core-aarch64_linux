require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.6.2.tgz"
  sha256 "9d6f7e3289c1798438079e4f43d479124ff8d345c0675313304af5707c9f7e2a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c01cf4f76b5377fc7fa900dd1260e2a8d6986de1af60d67948803186aede14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06c01cf4f76b5377fc7fa900dd1260e2a8d6986de1af60d67948803186aede14"
    sha256 cellar: :any_skip_relocation, monterey:       "58561a0f01f85f3e031fe868485a82151be072eab990a648b139e99b72016f1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "58561a0f01f85f3e031fe868485a82151be072eab990a648b139e99b72016f1b"
    sha256 cellar: :any_skip_relocation, catalina:       "58561a0f01f85f3e031fe868485a82151be072eab990a648b139e99b72016f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c01cf4f76b5377fc7fa900dd1260e2a8d6986de1af60d67948803186aede14"
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
