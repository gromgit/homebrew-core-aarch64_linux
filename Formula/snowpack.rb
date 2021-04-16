require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.1.tgz"
  sha256 "9d78a92e8feacf9b94973ea097189a1607e9a6e7c81f1b16da16f78fb1d0ea77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "166866001d67e5544955b3a012d459f9a0898f675173b673a3be5e74a87c76d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1648572b322ea689a1097ac534b1f91efabef57af05d57d19161d0aca1d7edf4"
    sha256 cellar: :any_skip_relocation, catalina:      "f0a1077ea7078aebda3e4fefd989054aed9d264ce0890d329506ceadfd110010"
    sha256 cellar: :any_skip_relocation, mojave:        "f5778f96245acf1357074cc10f7f1af4aa8c7efab5dd9ae5e506521af3b260db"
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
