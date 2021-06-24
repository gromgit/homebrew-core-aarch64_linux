require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.6.1.tgz"
  sha256 "b8e9e8efcee33169fe09f6f01115fa13eaf019ea3bfabf46ff94cc5b9022fc03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb7ba0db05f8fafbb2d6ced76fd734e73e189d2d3d677465f1598988bf198472"
    sha256 cellar: :any_skip_relocation, big_sur:       "a308d838a1e77ebd98554606a968cc2c29dfe993e60853f556c258a79d3f988f"
    sha256 cellar: :any_skip_relocation, catalina:      "a308d838a1e77ebd98554606a968cc2c29dfe993e60853f556c258a79d3f988f"
    sha256 cellar: :any_skip_relocation, mojave:        "a308d838a1e77ebd98554606a968cc2c29dfe993e60853f556c258a79d3f988f"
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
