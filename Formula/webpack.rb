require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-4.44.0.tgz"
  sha256 "5125d3ba5c4cd16cdb05d5c04de109ab8101cf357c9685ad3ae7da9b5102ad5e"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 "1631af75c86867cbfb97d2b6e703a87582a2e93983300970f8fbc791948511b9" => :catalina
    sha256 "16381df12722dc30fc393fa170b89b022accbc2d16c7e94cbdcd4f08dd631499" => :mojave
    sha256 "20c38097a47f49d5d61f4007711e9680438b4e09d07e22e94defd041cf5f96cb" => :high_sierra
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-3.3.11.tgz"
    sha256 "dace2e99dc7b819b4695c69c327a0da9f56f799f15d20346b22a6cc22c5fb794"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundledDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component () {
        var element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "index.js", "--output=bundle.js"
    assert_predicate testpath/"bundle.js", :exist?, "bundle.js was not generated"
  end
end
