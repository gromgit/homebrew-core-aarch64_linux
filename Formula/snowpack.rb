require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.4.0.tgz"
  sha256 "28e909cfba685ede729c9ba2d41258b4bfcb29f973a722e3d0f58e0fbb8828d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2db0cf93b34153bda5060b31e04d6cfd1c361f38b578d39c1c9ad1cb1919c96"
    sha256 cellar: :any_skip_relocation, big_sur:       "86c111cff9ff09247bcb23ebb96a66960b68d2f859a14edcbbd9639626130c6d"
    sha256 cellar: :any_skip_relocation, catalina:      "86c111cff9ff09247bcb23ebb96a66960b68d2f859a14edcbbd9639626130c6d"
    sha256 cellar: :any_skip_relocation, mojave:        "86c111cff9ff09247bcb23ebb96a66960b68d2f859a14edcbbd9639626130c6d"
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
