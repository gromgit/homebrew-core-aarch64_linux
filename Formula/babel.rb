require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.13.8.tgz"
  sha256 "227baef46da41d3034cfb147a90822d0f2ceaa4b20914281eed8e8a7b4127e47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a65ec25ec9f58abc3a6770d12062b8bf4083d57da25ce23ac89ca92bc0b544d"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee25cf4e90e5b1b2844c25d1fc5358d98d2b53492fa38948269f1a7523624d31"
    sha256 cellar: :any_skip_relocation, catalina:      "87b025d0a41fd21512c9de7a93625561679ea94d3c499b4d03f6fe6f1c1d6008"
    sha256 cellar: :any_skip_relocation, mojave:        "8e903f8411b787e6d45bb5cda7a2ae5389e16b1460f4732d85bf591f26985e17"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.13.0.tgz"
    sha256 "fc2d9effdf94122f84f3f0bc6f70e8b4b9f386ef259184da00d7d903bc98188f"
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
