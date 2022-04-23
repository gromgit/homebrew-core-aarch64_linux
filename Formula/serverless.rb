require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.15.2.tar.gz"
  sha256 "091a013732bf6da1eb9dada74cb0263d689f3428db1c46fc22d8f5ed0800b890"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fdb699bd133ef8fc79aaedb9d4a367f1b1b1d9f43198ca5bf0d6fe76c1c54cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2fdb699bd133ef8fc79aaedb9d4a367f1b1b1d9f43198ca5bf0d6fe76c1c54cb"
    sha256 cellar: :any_skip_relocation, monterey:       "9404fa26ac12781d92d6a71c7dbab788a530bd62d0a110c04b1e93677ba52a51"
    sha256 cellar: :any_skip_relocation, big_sur:        "9404fa26ac12781d92d6a71c7dbab788a530bd62d0a110c04b1e93677ba52a51"
    sha256 cellar: :any_skip_relocation, catalina:       "9404fa26ac12781d92d6a71c7dbab788a530bd62d0a110c04b1e93677ba52a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f29e20b63b03e0895fb88c9b1cda6111daee2db2a990a934bc23669b4f548d8"
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
