require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.20.0.tar.gz"
  sha256 "5a512d0807ffc8e8a67f36c0e0c3fb6713ed8ad3d2d65a1953966b2ce80ebcd8"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eae57c601164de257c3b3d6aeaaa0288bfb9c57e09ff32e25c1ae8e80e581af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6eae57c601164de257c3b3d6aeaaa0288bfb9c57e09ff32e25c1ae8e80e581af"
    sha256 cellar: :any_skip_relocation, monterey:       "8a26ec3e8dc17fb2ee1232b0297c361cd16ab3fdce9f6811147473126568668d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a26ec3e8dc17fb2ee1232b0297c361cd16ab3fdce9f6811147473126568668d"
    sha256 cellar: :any_skip_relocation, catalina:       "8a26ec3e8dc17fb2ee1232b0297c361cd16ab3fdce9f6811147473126568668d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d6d9c508591de44a93fbf48c037f1848481ef5494a55777216ee26856a208d"
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
