class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "https://www.ponylang.org/"
  url "https://github.com/ponylang/ponyc.git",
      tag:      "0.37.0",
      revision: "991bec5c43bd175bbb64e7400c08b1292e6d0538"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "98271b54f1ea1171b63e88d26e5093278553007d2c22d535a86499094b56f7e8" => :catalina
    sha256 "5167364b13e68c873d6141987e30a2a06e9d3d49da7c2b270aa2d8fba18fe959" => :mojave
    sha256 "0799b0a955962c33411b0261cadc2d4c556670b19a8094b5acabd21d61153db8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    ENV["MAKEFLAGS"] = "build_flags=-j#{ENV.make_jobs}"
    system "make", "libs"
    system "make", "configure"
    system "make", "build"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
