require "language/node"

class Unisonlang < Formula
  desc "Friendly programming language from the future"
  homepage "https://unison-lang.org/"
  url "https://github.com/unisonweb/unison.git",
      tag:      "release/M3",
      revision: "97cce8d23147df30b0f80ae745968db09f4e1a44"
  version "M3"
  license "MIT"
  head "https://github.com/unisonweb/unison.git", branch: "trunk"

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "node" => :build

  # stack/ghc currently have a number of issues building for aarch64
  # https://github.com/unisonweb/unison/issues/3136
  depends_on arch: :x86_64

  uses_from_macos "xz" => :build
  uses_from_macos "zlib"

  resource "codebase-ui" do
    url "https://github.com/unisonweb/codebase-ui/archive/refs/tags/release/M3.tar.gz"
    sha256 "84be9135a821615f8fc73a0a894aa46a11c55393c43dc26e16a5ce75f8063012"
    version "M3"
  end

  def install
    jobs = ENV.make_jobs
    ENV.deparallelize

    stack_args = [
      "-v",
      "--system-ghc",
      "--no-install-ghc",
      "--skip-ghc-check",
      "--copy-bins",
      "--local-bin-path=#{buildpath}",
    ]

    system "stack", "-j#{jobs}", "build", "--flag", "unison-parser-typechecker:optimized", *stack_args

    prefix.install "unison" => "ucm"
    bin.install_symlink prefix/"ucm"

    # Build and install the web interface
    resource("codebase-ui").stage do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"

      prefix.install "dist/unisonLocal" => "ui"
    end
  end

  test do
    # Ensure the codebase-ui version matches the ucm version
    assert_equal version, resource("codebase-ui").version

    # Initialize a codebase by starting the server/repl, but then run the "exit" command
    # once everything is set up.
    pipe_output("#{bin}/ucm -C ./", "exit")

    (testpath/"hello.u").write <<~EOS
      helloTo : Text ->{IO, Exception} ()
      helloTo name =
        printLine ("Hello " ++ name)

      hello : '{IO, Exception} ()
      hello _ =
        helloTo "Homebrew"
    EOS

    assert_match "Hello Homebrew", shell_output("#{bin}/ucm -C ./ run.file ./hello.u hello")
  end
end
