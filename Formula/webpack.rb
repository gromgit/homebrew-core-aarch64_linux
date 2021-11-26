require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.64.4.tgz"
  sha256 "54e408bd8d542b2448573fe4c78a1707d8499e5aa42ac39e168be1a1a6dcf95f"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be4ce1e6bb107dce467462d43d04869e85b342a248a4e145444783c9d9a672c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be4ce1e6bb107dce467462d43d04869e85b342a248a4e145444783c9d9a672c9"
    sha256 cellar: :any_skip_relocation, monterey:       "175e0c0fb4343b21bbefed26c87c186537dad7cb2e0fd205ea0ed95f17926b27"
    sha256 cellar: :any_skip_relocation, big_sur:        "175e0c0fb4343b21bbefed26c87c186537dad7cb2e0fd205ea0ed95f17926b27"
    sha256 cellar: :any_skip_relocation, catalina:       "175e0c0fb4343b21bbefed26c87c186537dad7cb2e0fd205ea0ed95f17926b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "304847d847587b81f50b6fde9d3edbd1f9e9f25569e9990eb682e3632fe210cc"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.9.1.tgz"
    sha256 "0e80f38d28019f7c30f7237ca0b7a250dfe0b561d07d8248b162dde663cd54ff"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
