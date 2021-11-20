require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.64.2.tgz"
  sha256 "3b48b3f5765cb297f27cdcd458a22b580385919d9b765659485df9934bc5440e"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7436ead893f10f054dccaa062d3267b8b8aff86d5fdbb3b6442a60024c372c87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7436ead893f10f054dccaa062d3267b8b8aff86d5fdbb3b6442a60024c372c87"
    sha256 cellar: :any_skip_relocation, monterey:       "17c0fe7816eacd787b8b022d8bb3289c0adb8df1e40806d663d18975877b2f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "17c0fe7816eacd787b8b022d8bb3289c0adb8df1e40806d663d18975877b2f5d"
    sha256 cellar: :any_skip_relocation, catalina:       "17c0fe7816eacd787b8b022d8bb3289c0adb8df1e40806d663d18975877b2f5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803a6000851403650d485a4db0419db93d25cd8a9c0a51159669910b8f4b0959"
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
