require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.64.1.tgz"
  sha256 "b7ad541ea8912e5435b434358c4737c775d12f0c2e42d85dc82d582591a0d66d"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8376d811e9e02a6c8676ce897624155dad5be3336e359e44ba158fc53b28d4d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8376d811e9e02a6c8676ce897624155dad5be3336e359e44ba158fc53b28d4d5"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9b42620cd8fad9775ed489b4ae6d80ae81af67d6c1466d27fd8ddd65ef1f29"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e9b42620cd8fad9775ed489b4ae6d80ae81af67d6c1466d27fd8ddd65ef1f29"
    sha256 cellar: :any_skip_relocation, catalina:       "4e9b42620cd8fad9775ed489b4ae6d80ae81af67d6c1466d27fd8ddd65ef1f29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0561f1f353c3d3d0dd52fcd686dc88734ef90871504501e8bed6844db640287"
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
