require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.3.tgz"
  sha256 "973e286b80ad4940eda7ea206f6b6dd759408c881493374f501a799cfcea24a9"

  bottle do
    sha256 "d272d7944deef563706ef25680b76c9fef95fe21b20f134b43d7aee7e1c5b11c" => :catalina
    sha256 "851f99d83cc1c69e6eec6a6cffda8927375c50191785651fc3b5076bb9df486c" => :mojave
    sha256 "207aa6ef6f0e592280d64732b697ce7ad78eee13c4df511a0e8236bc2039882e" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.3.tgz"
    sha256 "c9a8a6b594cd093732c02c8ed8598b071240c1972204f6bf09fa915208b335d1"
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
