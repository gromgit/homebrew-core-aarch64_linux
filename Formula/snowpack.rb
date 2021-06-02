require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.5.4.tgz"
  sha256 "4ee2f4f9323566f5e4b9431b188f89a344276ee288d730cfd6dc878f765d7f10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e77ca20fc9b3a8dbcd0b516aac72cef622435ddcc5c84f94ff35b13b4f75629"
    sha256 cellar: :any_skip_relocation, big_sur:       "a33a153b4329118ae9ea548d2bd2cf3ac2995fa303517dd6c5d12e0568c4a25a"
    sha256 cellar: :any_skip_relocation, catalina:      "a33a153b4329118ae9ea548d2bd2cf3ac2995fa303517dd6c5d12e0568c4a25a"
    sha256 cellar: :any_skip_relocation, mojave:        "a33a153b4329118ae9ea548d2bd2cf3ac2995fa303517dd6c5d12e0568c4a25a"
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
