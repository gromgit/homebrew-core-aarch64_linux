require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.3.tgz"
  sha256 "b73dddf3b8785e600243372df72d72e4206a27c431fe01a4374685b75a5548f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a4fa2f0926dc777f4d2821af230991bb07596ca875a5371cc60c8f52ed533b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "460e4288fa2b0059931ffb4e05ddbd20da5a6841a38ed0cb09c07f49b50b7b8e"
    sha256 cellar: :any_skip_relocation, catalina:      "460e4288fa2b0059931ffb4e05ddbd20da5a6841a38ed0cb09c07f49b50b7b8e"
    sha256 cellar: :any_skip_relocation, mojave:        "731901d8c6ed2a76717a078b305437d8c53c8907325127f5ea8a7f5b953dbac3"
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
