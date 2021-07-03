require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.15.5.tgz"
  sha256 "dbfbe9c5c571d19740f2118f0f023b38836be8ea2e49a1c9be402f108d2900e0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "14b22c6f20b67fc2274369bf14f680ece3b8f6b8b011eb656f8d1377bce77c13"
    sha256 big_sur:       "e5c381d7596650e45053cb53c5a50a3bdbf1a9fc938d79b429cca74663695828"
    sha256 catalina:      "73d9bd50115a34fd475921601120e2830285622dc791c441707fd20dd3b0556d"
    sha256 mojave:        "c457b7ba16b47849c6281e5de7fe006eca3703263d91a435e02a120921a4b8ad"
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
