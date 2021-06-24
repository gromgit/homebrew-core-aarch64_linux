require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.6.1.tgz"
  sha256 "b8e9e8efcee33169fe09f6f01115fa13eaf019ea3bfabf46ff94cc5b9022fc03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08909628cefed0f586d9ecacd5d4b97fb3aff5cc1532b64a3ca1f4dd5e2a0b3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "87180b3edf971b8619fb55a046df258858d9d10140f2477b8e605ae9c8a80044"
    sha256 cellar: :any_skip_relocation, catalina:      "87180b3edf971b8619fb55a046df258858d9d10140f2477b8e605ae9c8a80044"
    sha256 cellar: :any_skip_relocation, mojave:        "87180b3edf971b8619fb55a046df258858d9d10140f2477b8e605ae9c8a80044"
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
