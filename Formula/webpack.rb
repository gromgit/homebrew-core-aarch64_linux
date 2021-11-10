require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.63.0.tgz"
  sha256 "b3a6c32c570a4a19636cc7600e27e90f42fe8464c2980d447ee52dc414345527"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af31fa4722a74b9dab5398e1611c8b8e2be187bcf167cabd24e108ddf3489ea8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af31fa4722a74b9dab5398e1611c8b8e2be187bcf167cabd24e108ddf3489ea8"
    sha256 cellar: :any_skip_relocation, monterey:       "7251bf111224ee768c079fa4accb9e707d50415455cc157ab0c355b0e2c2a549"
    sha256 cellar: :any_skip_relocation, big_sur:        "7251bf111224ee768c079fa4accb9e707d50415455cc157ab0c355b0e2c2a549"
    sha256 cellar: :any_skip_relocation, catalina:       "7251bf111224ee768c079fa4accb9e707d50415455cc157ab0c355b0e2c2a549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdbafebd678984fbaea9929dd3ad93e38e5540a1a8ce8f7ac35022f286470375"
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
