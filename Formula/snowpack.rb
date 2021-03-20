require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.1.1.tgz"
  sha256 "2570d0f67000054019af498546bcd9f4f6f81491ed359e09bc22545928af8821"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6887384b2f2f2bdeac47e10ff51a424ef2c249e5b775a9094562c235d244ec9"
    sha256 cellar: :any_skip_relocation, big_sur:       "c7e0ade4eb3b0ac8ec8c97074d396d985786a1b2f16c6c06239729015d2c82d6"
    sha256 cellar: :any_skip_relocation, catalina:      "ce0942f5ce93948ef471755c3bedd5797cf14259ddd5e6f80ffe76aaf983f3eb"
    sha256 cellar: :any_skip_relocation, mojave:        "b598a472e11525fd5dd5baede636cd8b87a2cf4394ca98f8f0716b39941c0a48"
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
