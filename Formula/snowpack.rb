require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.3.5.tgz"
  sha256 "c2b52d27be57f7994c6a177acac56a88ec244a2155620c7e830266f9710fa616"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "53e4ab17c9f8737ab8522e29da93fbded1f2353c1640274073aea4b310f61e9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc12c38f70202b457d7917cdac10cb500aff15f95dffa45cf556ab037ec5daa6"
    sha256 cellar: :any_skip_relocation, catalina:      "fc12c38f70202b457d7917cdac10cb500aff15f95dffa45cf556ab037ec5daa6"
    sha256 cellar: :any_skip_relocation, mojave:        "d304383fa4a96156f49a02228e5f45522e278335813ae01749087197dddd415a"
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
