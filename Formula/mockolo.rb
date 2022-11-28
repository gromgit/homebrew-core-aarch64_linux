class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/1.7.0.tar.gz"
  sha256 "b36c49d835895b643e631c5cba3c9048f0628f68d37c5adf739a30de93677304"
  license "Apache-2.0"

  depends_on xcode: ["12.5", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write <<~EOS
      /// @mockable
      public protocol Foo {
          var num: Int { get set }
          func bar(arg: Float) -> String
      }
    EOS
    system "#{bin}/mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    output = <<~EOS.gsub(/\s+/, "").strip
      ///
      /// @Generated by Mockolo
      ///
      public class FooMock: Foo {
        public init() { }
        public init(num: Int = 0) {
            self.num = num
        }

        public private(set) var numSetCallCount = 0
        public var num: Int = 0 { didSet { numSetCallCount += 1 } }

        public private(set) var barCallCount = 0
        public var barHandler: ((Float) -> (String))?
        public func bar(arg: Float) -> String {
            barCallCount += 1
            if let barHandler = barHandler {
                return barHandler(arg)
            }
            return ""
        }
      }
    EOS
    assert_equal output, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
