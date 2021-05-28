require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.2.tgz"
  sha256 "1f56d7d2ef4aa344a443df02aa9ca91739dc89ad1d531d514782bb93c1ab5695"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53eb82d97aafb220b00de720037e095831b90bf1a40d74b515ca79c96a14a16a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b45f29acb9e0d814afd75e5df26bd13635d37302c5dd5f030921f4f98540e697"
    sha256 cellar: :any_skip_relocation, catalina:      "b45f29acb9e0d814afd75e5df26bd13635d37302c5dd5f030921f4f98540e697"
    sha256 cellar: :any_skip_relocation, mojave:        "b45f29acb9e0d814afd75e5df26bd13635d37302c5dd5f030921f4f98540e697"
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
