class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/lpil/gleam/archive/v0.11.1.tar.gz"
  sha256 "608209cdbc041e8a4fe5ca5b19c4f8002725b887f393f96b9d5cc0a01a44517c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ee102b22907f603eccf80a6c602c0148a9d126d90700b8fa5b616c653e5db20" => :catalina
    sha256 "c9601cf7e9c5787188a67c7c3cb2ea6ed83348dc40c74c00e8bcaa23dea6dfd5" => :mojave
    sha256 "ef7836c4a212db613622287a290026faeb02b184e331974cb59f0aa9282f4176" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    Dir.chdir testpath
    system "#{bin}/gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "rebar3", "eunit"
  end
end
