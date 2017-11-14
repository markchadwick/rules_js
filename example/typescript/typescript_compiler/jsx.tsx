
const React: any = {}

export interface Props {
  name: string
}

export const BigName = (props: Props) => {
  <h1>{props.name}</h1>
}
