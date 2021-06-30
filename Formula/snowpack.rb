require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.7.1.tgz"
  sha256 "ac13f33efd2ae9b6210d4b41d2b045c7c6c97d4b391391271b3ed874e449cf95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "03d60a0a0d5dae9d7e25dcd270c690fb5e04902fed737be98bd5f641ff6109ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce26a723ed84402cbd33abea60218efe7de947f5d609c98a63ebbf441f8641be"
    sha256 cellar: :any_skip_relocation, catalina:      "ce26a723ed84402cbd33abea60218efe7de947f5d609c98a63ebbf441f8641be"
    sha256 cellar: :any_skip_relocation, mojave:        "ce26a723ed84402cbd33abea60218efe7de947f5d609c98a63ebbf441f8641be"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system "npm", "init", "-y"
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
