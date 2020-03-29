import $ivy.`org.typelevel::cats-core:2.1.0`,
  cats._,
  cats.data._,
  cats.implicits._
import $ivy.`org.typelevel::cats-effect:2.1.0`,
  cats.effect._

import $ivy.`co.fs2::fs2-core:2.1.0`, fs2.Stream
import $ivy.`co.fs2::fs2-io:2.1.0`

// library treasure trove
import $ivy.`com.chuusai::shapeless:2.3.3`
import $ivy.`eu.timepit::refined:0.9.12`
import $ivy.`io.circe::circe-core:0.12.3`
import $ivy.`io.circe::circe-generic:0.12.3`
import $ivy.`io.circe::circe-literal:0.12.3`
import $ivy.`io.circe::circe-parser:0.12.3`
import $ivy.`io.circe::circe-refined:0.12.3`

// plugins
import $plugin.$ivy.`org.typelevel:::kind-projector:0.11.0`
// import $plugin.$ivy.`org.typelevel:kind-projector_2.13.1:0.11.0`
// import $plugin.$ivy.`org.typelevel::simulacrum:1.0.0`
// import $ivy.`org.typelevel::simulacrum:1.0.0`

import scala.concurrent.ExecutionContext
import scala.concurrent.duration._

repl.prompt() = "scala> "

// repl.pprinter.update(repl.pprinter().copy(additionalHandlers = {
//   case io: IO[_] => pprint.Tree.Literal("???")
// }))

interp.configureCompiler(_.settings.YmacroAnnotations.value = true)
interp.configureCompiler(_.settings.Ydelambdafy.tryToSetColon(List("inline")))

// provide some useful implicits for cats-effect
implicit val contextShiftIO: ContextShift[IO] =
  IO.contextShift(ExecutionContext.global)
implicit val timerIO: Timer[IO] =
  IO.timer(ExecutionContext.global)
implicit val blockerIO: Blocker =
  Blocker.liftExecutionContext(ExecutionContext.global)

// shortcuts
implicit class IOOps[F](io: IO[F]) {
  def run(): F = io.unsafeRunSync()
  def r(): F = run()
}
