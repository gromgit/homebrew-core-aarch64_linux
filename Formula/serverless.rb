require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.21.0.tar.gz"
  sha256 "b8b7d873998c746c15f8e0fadaa70a51845be71b6156304bf83d46ea65447437"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff6ded140d098f993b2019dba68b98d9e6eab263c285265e531492d735a37b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ff6ded140d098f993b2019dba68b98d9e6eab263c285265e531492d735a37b6"
    sha256 cellar: :any_skip_relocation, monterey:       "21687fff717e812f215b692fc64cd318f029f681e6d45fdeb4f34d757133ebfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "21687fff717e812f215b692fc64cd318f029f681e6d45fdeb4f34d757133ebfb"
    sha256 cellar: :any_skip_relocation, catalina:       "21687fff717e812f215b692fc64cd318f029f681e6d45fdeb4f34d757133ebfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84ea6db2f1ac37cd6ccadd16db7eca78bb620f528d13526d5580fe99073cef8c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Delete incompatible Linux CPython shared library included in dependency package.
    # Raise an error if no longer found so that the unused logic can be removed.
    (libexec/"lib/node_modules/serverless/node_modules/@serverless/dashboard-plugin")
      .glob("sdk-py/serverless_sdk/vendor/wrapt/_wrappers.cpython-*-linux-gnu.so")
      .map(&:unlink)
      .empty? && raise("Unable to find wrapt shared library to delete.")

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"lib/node_modules/serverless/node_modules/fsevents/fsevents.node"
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package 2>&1")
    assert_match "Packaging homebrew-test for stage dev", output
  end
end
