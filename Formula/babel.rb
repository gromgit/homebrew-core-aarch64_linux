require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.7.4.tgz"
  sha256 "3bb9a1d79c68a0c1c41885b86471d306b99efefabb2def80ea3a511d3476f048"

  bottle do
    sha256 "0f17ef20a93d927fd499e56bbf80952348a0648bd13c0daff7b48a9c38145dc7" => :catalina
    sha256 "83a2fff8d5318875ae2f7152a18ebc2350651c7ed4e88fa53065f004b1f4d715" => :mojave
    sha256 "20579144803ca5296abb313f7438c97a87bb229aa494e4f8c6bf9ade5bb5addf" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.7.4.tgz"
    sha256 "07b17689c27908ff2e64cfb0502e79aa4425b79bcdc740e029897a20d4f4a9a7"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
