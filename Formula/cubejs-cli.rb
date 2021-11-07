require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.53.tgz"
  sha256 "6024718834d7282212dec4b774d874fdd0ca59ade46b47014caa0febd1a13cef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f0f8cafc9e2e395584e674cf7bd9dbe4c2945ac8dc77e0a46bf4ec0aae1b3df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f0f8cafc9e2e395584e674cf7bd9dbe4c2945ac8dc77e0a46bf4ec0aae1b3df"
    sha256 cellar: :any_skip_relocation, monterey:       "cc95e9f9347ab429d240921ed09f4292babc69fdb6c3f7b34a5f5b643d35b624"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc95e9f9347ab429d240921ed09f4292babc69fdb6c3f7b34a5f5b643d35b624"
    sha256 cellar: :any_skip_relocation, catalina:       "cc95e9f9347ab429d240921ed09f4292babc69fdb6c3f7b34a5f5b643d35b624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0f8cafc9e2e395584e674cf7bd9dbe4c2945ac8dc77e0a46bf4ec0aae1b3df"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
