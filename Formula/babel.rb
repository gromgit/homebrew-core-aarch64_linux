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
    rebuild 1
    sha256 "4406c70c05dc0e45ead7a898f279f280b9b6b95474e56808e01ded0197e0451b" => :big_sur
    sha256 "bf09fe7aac5c201ae31d832c41696fd04ae67546e596ab5839e21584f5bcc9ad" => :catalina
    sha256 "250e7bf00cf6396d63e410532d0e42cc8245410b269c4f40d85450f45941a01e" => :mojave
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
