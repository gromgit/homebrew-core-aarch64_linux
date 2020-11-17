require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.3.tgz"
  sha256 "a7ea7ba65beec126c6cf62e17d6274b97179fbd7aee2e0199a804b927c8c2427"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a959a7c232b25cc5f4e4c52442c6003108188e430b3bff4b3b55b0855f0aeda1" => :catalina
    sha256 "192f3d82298e2d2698d967414756cc15396a6ff79c6bfe5c494524f421467a38" => :mojave
    sha256 "6a6628757ef6b5bf29ba5511fb662f78207986c6129ecbf9c7607026e4edc44c" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.1.tgz"
    sha256 "f3df18f3c37e4bcb0294b3e4ccdbd5eef14debdf4bb83120f660b36be7418c94"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
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
