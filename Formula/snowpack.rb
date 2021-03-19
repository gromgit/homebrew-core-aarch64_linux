require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.1.1.tgz"
  sha256 "2570d0f67000054019af498546bcd9f4f6f81491ed359e09bc22545928af8821"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4148264a15951547102b58c903a2f34709b79643d4d4991789aac3d9d8d65219"
    sha256 cellar: :any_skip_relocation, big_sur:       "b99f05b87d6539b8312e7cf983e2fc7027f5372649b91907c187b63d7deaa323"
    sha256 cellar: :any_skip_relocation, catalina:      "e45083a22c9a458ae356f158199c73ad5a7210f10d5a6b4d0e369f6d2d2d2b3a"
    sha256 cellar: :any_skip_relocation, mojave:        "8bec25b62e92fc68ba75c975df570fc6fcaff05684c2a848c6252487bd51d9be"
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
