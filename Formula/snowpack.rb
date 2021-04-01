require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.2.2.tgz"
  sha256 "a3861bb50b1578c882841adea0f79e5e57d3b4e2b4378eac52c699d1b1445b17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5c2d32a76870803119ce3547ce982c5c9e2234a104ce29db1c50573c1888307"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c77711e6351c00408a0461f60609b48d614497c6755b148258c3bd99196d890"
    sha256 cellar: :any_skip_relocation, catalina:      "a3521b9da69be7ebb4187fff195d77bdc6fac35cc3e1bfefb7d14bf7d1664347"
    sha256 cellar: :any_skip_relocation, mojave:        "9045d6312709be2d62d155f39558a8f1918863f9de342146dbf881f40f58ea98"
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
