require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.15.6.tgz"
  sha256 "32cb9c1a7453b829071d682a00fc03a86ed28bad1f21515349241c088e1c2ff9"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "768ed3e9e138c783576c0589fe6eecb61bf890575075b327646bf72f0cbf462e"
    sha256                               big_sur:       "f0bfe043e1f477e5e2d65363b00fc71c8c80460776c2d97a83ee66f4271d0a8e"
    sha256                               catalina:      "0f9b7a365f0bdabb7a9951c945f2a1ae1cbd4f4a3e501c620e9065eda2467aba"
    sha256                               mojave:        "d93e60477ffca41474cf62cc36a35f863f7d405c0afbfacb095991a10984fe97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94a74891dad65d667ec4b1feac2c92b7dcfecf79f7cb16548a8f081094c22ea"
  end

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
