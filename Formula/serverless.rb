require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v3.22.0.tar.gz"
  sha256 "f1e0c486b3792ca10a152f339fff56dbda64eab39ece1e34eb89d5fb1c4d23ef"
  license "MIT"
  head "https://github.com/serverless/serverless.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbd2953055332c0a596e53d102e8f80f1c47f5b9c3d1566ef743c8cce4ac9871"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbd2953055332c0a596e53d102e8f80f1c47f5b9c3d1566ef743c8cce4ac9871"
    sha256 cellar: :any_skip_relocation, monterey:       "1e7a2e2409fb564f0596edc002e897e326737c9e868e3212466baffbc8b42895"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e7a2e2409fb564f0596edc002e897e326737c9e868e3212466baffbc8b42895"
    sha256 cellar: :any_skip_relocation, catalina:       "1e7a2e2409fb564f0596edc002e897e326737c9e868e3212466baffbc8b42895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82efe8bad35c6f421da6d2aa201219fee02ac195584913f93a2dd37ad1fe8d74"
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
