require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.7.tgz"
  sha256 "1c75490763f575037627f2f73e8249678fcc4296d2d68d79a1974dfd38dd6406"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8959295694a1629d231c3b26eb14aab53222df672696efd026ff0e0657353d62"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1b0c90509739a9d9ab8d532435976d72336eb610316fb1b8c90ea49965ffae2"
    sha256 cellar: :any_skip_relocation, catalina:      "d1b0c90509739a9d9ab8d532435976d72336eb610316fb1b8c90ea49965ffae2"
    sha256 cellar: :any_skip_relocation, mojave:        "d1b0c90509739a9d9ab8d532435976d72336eb610316fb1b8c90ea49965ffae2"
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
