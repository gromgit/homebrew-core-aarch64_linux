require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.2.tgz"
  sha256 "88f246ef2dfce0ef37afe25e0cff9d35733dc5ad6d980f2199c6feddede486d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "161aa1d9adf5f0a2aa05d44cf3d51aec98e0cf7402cc7cadbce745043387772a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "161aa1d9adf5f0a2aa05d44cf3d51aec98e0cf7402cc7cadbce745043387772a"
    sha256 cellar: :any_skip_relocation, monterey:       "f23398671b6c77fd14c117a76eb69fd619006dc5b08288c64fa2a4238c1ca16b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f23398671b6c77fd14c117a76eb69fd619006dc5b08288c64fa2a4238c1ca16b"
    sha256 cellar: :any_skip_relocation, catalina:       "f23398671b6c77fd14c117a76eb69fd619006dc5b08288c64fa2a4238c1ca16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b358933ae47d51e0c7c14141ea6a95c8d8d8ec0ac97587745023d4d28415e47"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
