require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.21.8.tgz"
  sha256 "cc20ad80a7c0fee15516b54a491688aeb74b3d9c8697f1f2fd15228a8c962657"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ad08a7baab46ccf8bd39c170bff57a1f8d93afbbefd9f0fa03994725ba3465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40ad08a7baab46ccf8bd39c170bff57a1f8d93afbbefd9f0fa03994725ba3465"
    sha256 cellar: :any_skip_relocation, monterey:       "9f1e9a741d7a34e747102a30039068d5edc1691f167d7addfbe0803db6bd9670"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f1e9a741d7a34e747102a30039068d5edc1691f167d7addfbe0803db6bd9670"
    sha256 cellar: :any_skip_relocation, catalina:       "9f1e9a741d7a34e747102a30039068d5edc1691f167d7addfbe0803db6bd9670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e377224ec41530a930723e511d3b66ab6e008a088e0165d50f8b98a3ae6ec37c"
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
