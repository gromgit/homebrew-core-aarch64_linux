require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.23.0.tar.gz"
  sha256 "4f05e15e551e0bad12315f2cfff30b425db03f83ee63dd8fd07f720665d82e5f"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e6eb3ef2d9fc9bf1cf36c79d5f497b7daee8a1a142a14759736a88e8f9ca37d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e6eb3ef2d9fc9bf1cf36c79d5f497b7daee8a1a142a14759736a88e8f9ca37d"
    sha256 cellar: :any_skip_relocation, monterey:       "6c188bd17235a4bf72e86bb158c367019dcc60e874c1a1430d8bc80ff40086da"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c188bd17235a4bf72e86bb158c367019dcc60e874c1a1430d8bc80ff40086da"
    sha256 cellar: :any_skip_relocation, catalina:       "6c188bd17235a4bf72e86bb158c367019dcc60e874c1a1430d8bc80ff40086da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16ebb7b216bd9dbc1d78d11e29280ac79e29f1ec955b3e80342e910cad2f8d1"
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
