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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254b038746d882d133bca695cc81c58fe5e88d3efa801fe21ccd6c3af00cb43a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "254b038746d882d133bca695cc81c58fe5e88d3efa801fe21ccd6c3af00cb43a"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5672965e73bffe00bf3ccd5ddf891333a009816ce4fb03037eb3c05411e663"
    sha256 cellar: :any_skip_relocation, big_sur:        "f16acb98e060ecaffe3b45de580b9478a858b663d99086a90a89cb21a73aacfa"
    sha256 cellar: :any_skip_relocation, catalina:       "f16acb98e060ecaffe3b45de580b9478a858b663d99086a90a89cb21a73aacfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c0d8cff6dda80aba2da435c9fd62b9fd6d9884df5c21ebe2d5f849d200929d"
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
