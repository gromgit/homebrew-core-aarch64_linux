class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.0.tar.xz"
  sha256 "257ef3727c462795f8e599771f18272b772beb854aacab97e0fda70c13745e0c"
  license "MIT"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/qbe"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8c75c62763b554f31b22612a40bd9683572da29841d789c20ebe765369a769ca"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"main.ssa").write <<~EOS
      function w $add(w %a, w %b) {        # Define a function add
      @start
        %c =w add %a, %b                   # Adds the 2 arguments
        ret %c                             # Return the result
      }
      export function w $main() {          # Main function
      @start
        %r =w call $add(w 1, w 1)          # Call add(1, 1)
        call $printf(l $fmt, ..., w %r)    # Show the result
        ret 0
      }
      data $fmt = { b "One and one make %d!\n", b 0 }
    EOS

    system "#{bin}/qbe", "-o", "out.s", "main.ssa"
    assert_predicate testpath/"out.s", :exist?
  end
end
