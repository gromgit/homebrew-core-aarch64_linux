require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.5.tgz"
  sha256 "edee1808b2b97df6c2b7b3420fc9ed840d9c006112ff4242e9f220cf3be23c09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22446ae29d4614909f6ea39e2128bfbfb9f0a81403fc4950ec090c95c0fae05e"
    sha256 cellar: :any_skip_relocation, big_sur:       "15d33fad20f81aed942814c4478bbc1f3f0b8c15d2c373d4f8e2b4bcb05b6bc0"
    sha256 cellar: :any_skip_relocation, catalina:      "15d33fad20f81aed942814c4478bbc1f3f0b8c15d2c373d4f8e2b4bcb05b6bc0"
    sha256 cellar: :any_skip_relocation, mojave:        "15d33fad20f81aed942814c4478bbc1f3f0b8c15d2c373d4f8e2b4bcb05b6bc0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system bin/"snowpack", "init"
      assert_predicate testpath/"work/snowpack.config.js", :exist?

      inreplace testpath/"work/snowpack.config.js",
        "  packageOptions: {\n    /* ... */\n  },",
        "  packageOptions: {\n    source: \"remote\"\n  },"
      system bin/"snowpack", "add", "react"
      deps_contents = File.read testpath/"work/snowpack.deps.json"
      assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

      assert_match "Build Complete", shell_output("#{bin}/snowpack build")
    end
  end
end
