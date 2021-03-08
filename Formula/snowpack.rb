require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.0.13.tgz"
  sha256 "35cf6805e4253f22a79a1496f529f88c39a441d798b0e691c53cd94e1413516f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"snowpack", "init"
    assert_predicate testpath/"snowpack.config.js", :exist?

    inreplace testpath/"snowpack.config.js",
      "  packageOptions: {\n    /* ... */\n  },",
      "  packageOptions: {\n    source: \"remote\"\n  },"
    system bin/"snowpack", "add", "react"
    deps_contents = File.read testpath/"snowpack.deps.json"
    assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

    system bin/"snowpack", "build"
    assert_predicate testpath/"build/_snowpack/env.js", :exist?
  end
end
